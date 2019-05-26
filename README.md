# Saily Package Manager (Internal Beta)
### "Apple's Package Manager."  
![avatar](https://github.com/SailyTeam/Saily/raw/master/Artwork/LongBG.png)
## ALERT: 
#### WE EXPECT THAT, AS AN INTERNAL TESTER, YOU DO NOT SHARE SAILY OR MAKE IT PUBLICLY KNOWN YET! Saily is still in an early beta stage and is not ready for end users just yet. Saily will remain at version 0.1.2 for some time as the the backend is being improved. Please be patient. For support, please contact @SailySupport on Twitter. For updates, follow @TrySaily on Twitter.

## Deployment Targets:  
  - Jailbroken *test* devices running iOS 11
  - Jailbroken *test* devices running iOS 12
  - *NOTICE: It is NOT RECOMMENDED that you run Saily on your everyday device at this time.*
  
## Installation Instructions:
  1. Go to the following directory:
  Saily/SailyPackageManager/Packages
  2. Download Saily.deb & SailyStartupDaemon.deb
  3. Install both with Filza
  4. Respring
  5. Enjoy!
  
## Requirements (Self-Compilers Only):
  - Xcode 10 And Swift 5 +
  - cocoaPods  (pod install)
  - MonkeyDev (theos or more is included)
  - MAKE SURE YOU UNDERSTAND BUILD SCRIPT IN EACH TARGET
  
## Known Issues:
  - Any repo that fails to load may cause bad builds of root packages. 
  - WebKit crashes may still exist.
  - DPKG with Chimera is known to cause crashes.
  - *All known issues were fixed in version 0.2 and will not be present in the next update.*
  
## To-Do List:
  - Document everything
  - Dameon & App authorization surface
  - Update detection
  - Sileo compatibility & payment support
  - Setting pages
  - APT auto removal
  - Update history
  - Fix any possible errors
