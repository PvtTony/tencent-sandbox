$LanguageList = Get-WinUserLanguageList

$LanguageList.Add("zh-Hans-CN")

Set-WinUserLanguageList $LanguageList -Force

# Setting Up Locale
Set-WinSystemLocale -SystemLocale zh-CN
Set-WinHomeLocation -GeoID 45
Set-Culture zh-CN
Set-WinUILanguageOverride -Language zh-CN

# Setting up wallpaper
$path = "C:\Scripts\Wallpaper.jpg"
$setwallpapersrc = @"
using System.Runtime.InteropServices;
public class Wallpaper
{
  public const int SetDesktopWallpaper = 20;
  public const int UpdateIniFile = 0x01;
  public const int SendWinIniChange = 0x02;
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  private static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
  public static void SetWallpaper(string path)
  {
    SystemParametersInfo(SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange);
  }
}
"@
Add-Type -TypeDefinition $setwallpapersrc
[Wallpaper]::SetWallpaper($path)

# Remove News and Interest Using Powershell
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Value 2

# Remove SearchBar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0

# Enable dark mode for apps
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0

# Enable dark mode for system
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0

# Disable showing frequently used folders in Quick Access
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Value 1

# Getting the explorer process
$process = Get-Process explorer

# Stopping the explorer process
Stop-Process -Name $process.Name -Force 

# Starting the explorer process
Start-Process "explorer.exe" -ArgumentList '/root,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}' -WindowStyle Hidden