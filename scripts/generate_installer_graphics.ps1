# PowerShell script to generate custom WiX installer banners from app_icon.png
Add-Type -AssemblyName System.Drawing

$srcLogoPath = "lib\assets\app_icon.png"
if (-not (Test-Path $srcLogoPath)) {
    Write-Error "Source app_icon.png not found at $srcLogoPath"
}

$srcLogo = [System.Drawing.Image]::FromFile((Resolve-Path $srcLogoPath))

# 1. Generate WixUIDialogBmp (493 x 312) - Welcome/Completion Dialog Banner
$dlgWidth = 493
$dlgHeight = 312
$dlgBmp = New-Object System.Drawing.Bitmap($dlgWidth, $dlgHeight)
$gDlg = [System.Drawing.Graphics]::FromImage($dlgBmp)
$gDlg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gDlg.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

# Dark sleek background for the left 164px sidebar panel
$brushLeft = New-Object System.Drawing.SolidBrush([System.Drawing.ColorTranslator]::FromHtml("#0F172A"))
$gDlg.FillRectangle($brushLeft, 0, 0, 164, 312)

# White background for right side 329px where text is displayed
$brushRight = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$gDlg.FillRectangle($brushRight, 164, 0, 329, 312)

# Draw Logo centered on the left 164x312 sidebar
$logoSize = 120
$logoX = [int]((164 - $logoSize) / 2)
$logoY = [int]((312 - $logoSize) / 2)
$gDlg.DrawImage($srcLogo, $logoX, $logoY, $logoSize, $logoSize)

$dlgBmp.Save("windows\installer\dlgbmp.bmp", [System.Drawing.Imaging.ImageFormat]::Bmp)
$gDlg.Dispose()
$dlgBmp.Dispose()

# 2. Generate WixUIBannerBmp (493 x 58) - Interior Dialog Header Banner
$bannerWidth = 493
$bannerHeight = 58
$bannerBmp = New-Object System.Drawing.Bitmap($bannerWidth, $bannerHeight)
$gBanner = [System.Drawing.Graphics]::FromImage($bannerBmp)
$gBanner.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$gBanner.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

# White background for top header banner
$gBanner.FillRectangle($brushRight, 0, 0, $bannerWidth, $bannerHeight)

# Draw small logo on right side of top banner
$smLogoSize = 46
$gBanner.DrawImage($srcLogo, ($bannerWidth - $smLogoSize - 10), 6, $smLogoSize, $smLogoSize)

$bannerBmp.Save("windows\installer\bannrbmp.bmp", [System.Drawing.Imaging.ImageFormat]::Bmp)
$gBanner.Dispose()
$bannerBmp.Dispose()
$srcLogo.Dispose()

Write-Host "Successfully generated installer graphics:"
Write-Host "- windows\installer\dlgbmp.bmp"
Write-Host "- windows\installer\bannrbmp.bmp"
