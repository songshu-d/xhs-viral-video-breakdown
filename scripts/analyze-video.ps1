param(
  [Parameter(Mandatory=$true)][string]$InputVideo,
  [Parameter(Mandatory=$true)][string]$OutputDir,
  [double]$SceneThreshold = 0.22,
  [int]$SheetSeconds = 30
)

$ErrorActionPreference = 'Stop'

function Resolve-MediaTool([string]$Name) {
  $cmd = Get-Command $Name -ErrorAction SilentlyContinue
  if ($cmd) { return $cmd.Source }
  $cache = Join-Path $env:USERPROFILE '.chatcut\cache\ffmpeg'
  $candidate = Get-ChildItem -LiteralPath $cache -Recurse -Filter "$Name.exe" -ErrorAction SilentlyContinue |
    Sort-Object FullName -Descending |
    Select-Object -First 1
  if ($candidate) { return $candidate.FullName }
  throw "$Name was not found on PATH or in the ChatCut cache."
}

$ffmpeg = Resolve-MediaTool 'ffmpeg'
$ffprobe = Resolve-MediaTool 'ffprobe'
$input = (Resolve-Path -LiteralPath $InputVideo).Path
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null
$out = (Resolve-Path -LiteralPath $OutputDir).Path
$sheets = Join-Path $out 'contact-sheets'
New-Item -ItemType Directory -Force -Path $sheets | Out-Null

& $ffprobe -v error -show_entries 'format=duration,bit_rate:stream=index,codec_type,codec_name,width,height,r_frame_rate,sample_rate,channels' -of json $input |
  Set-Content -LiteralPath (Join-Path $out 'probe.json') -Encoding utf8

$durationText = & $ffprobe -v error -show_entries 'format=duration' -of 'default=noprint_wrappers=1:nokey=1' $input
$duration = [double]::Parse($durationText.Trim(), [Globalization.CultureInfo]::InvariantCulture)

$sceneLog = Join-Path $out 'scene-analysis.log'
$sceneFilter = "select='gt(scene,$SceneThreshold)',showinfo"
$sceneCommand = ('""{0}" -hide_banner -i "{1}" -vf "{2}" -an -f null NUL 2>&1"' -f $ffmpeg, $input, $sceneFilter)
$sceneLines = & cmd.exe /d /s /c $sceneCommand
$sceneLines | Set-Content -LiteralPath $sceneLog -Encoding utf8
$cuts = foreach ($line in $sceneLines) {
  if ($line -match 'pts_time:([0-9.]+)') { $matches[1] }
}
$cuts | Set-Content -LiteralPath (Join-Path $out 'scene-cuts.txt') -Encoding utf8

for ($start = 0; $start -lt $duration; $start += $SheetSeconds) {
  $remaining = [Math]::Min($SheetSeconds, $duration - $start)
  $name = 'sheet_{0:D4}.jpg' -f [int]$start
  & $ffmpeg -hide_banner -loglevel error -ss $start -t $remaining -i $input `
    -vf 'fps=1,scale=180:320,tile=6x5:padding=2:margin=2:color=black' `
    -frames:v 1 -y (Join-Path $sheets $name)
}

[pscustomobject]@{
  input = $input
  durationSeconds = [Math]::Round($duration, 3)
  ffmpeg = $ffmpeg
  ffprobe = $ffprobe
  sceneCutCount = @($cuts).Count
  outputDir = $out
} | ConvertTo-Json -Depth 3
