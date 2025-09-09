# Service-Worker:

</br>

```ruby
Compiler    : Delphi7 (or Higher)
Components  : WinSvc.pas
Discription : Working with the Windows Service outside the Console
Last Update : 09/2025
License     : Freeware
```

</br>

In Windows Operating Systems, a Windows service is a computer program that [operates in the background](https://en.wikipedia.org/wiki/Background_process). It is similar in concept to a [Unix](https://en.wikipedia.org/wiki/Unix) [daemon](https://en.wikipedia.org/wiki/Daemon_(computing)). A Windows service must conform to the interface rules and protocols of the Service Control Manager, the component responsible for managing Windows services. It is the Services and Controller app, services.exe, that launches all the services and manages their actions, such as start, end, etc.

</br>

### Features:
* Sart / Stop Service
* Pause / Continue Service
* Un / Install Service

</br>

![Service Worker](https://github.com/user-attachments/assets/534aa670-57a1-4815-8774-2621dd9bb482)

</br>

Windows services can be configured to start when the operating system is started and run in the background as long as Windows is running. Alternatively, they can be started manually or by an event. Windows NT operating systems [include numerous services ](https://en.wikipedia.org/wiki/List_of_Microsoft_Windows_components#Services)which run in context of three [user accounts](https://en.wikipedia.org/wiki/User_(computing)): System, Network Service and Local Service. These Windows components are often associated with [Host Process for Windows Services](https://en.wikipedia.org/wiki/Svchost.exe). Because Windows services operate in the context of their own dedicated user accounts, they can operate when a user is not logged on.

Prior to [Windows Vista](https://en.wikipedia.org/wiki/Windows_Vista), services installed as an "interactive service" could interact with Windows desktop and show a [graphical user interface](https://en.wikipedia.org/wiki/Graphical_user_interface). In Windows Vista, however, interactive services are deprecated and may not operate properly, as a result of [Windows Service hardening](https://en.wikipedia.org/wiki/Security_and_safety_features_new_to_Windows_Vista#Windows_Service_Hardening).

### Administration:
Windows administrators can manage services via:

* [The Services snap-in](https://en.wikipedia.org/wiki/Plug-in_(computing)) (found under Administrative Tools in Windows Control Panel)
* Sc.exe
* [Windows PowerShell](https://en.wikipedia.org/wiki/Windows_PowerShell)

### Services Snap-in:
The Services snap-in, built upon [Microsoft Management Console](https://en.wikipedia.org/wiki/Microsoft_Management_Console), can connect to the local computer or a remote computer on the network, enabling users to:

* View a list of installed services along with service name, descriptions and configuration
* Start, stop, pause or restart services
* Specify service parameters when applicable
* Change the startup type. Acceptable startup types include:
  * Automatic: The service starts at system startup.
  * Automatic (Delayed): The service starts a short while after the system has finished starting up. This option was introduced in Windows Vista in an attempt to reduce the boot-to-desktop time. However, not all services support delayed start.
  * Manual: The service starts only when explicitly summoned.
  * Disabled: The service is disabled. It will not run.
* Change the user account context in which the service operates
* Configure recovery actions that should be taken if a service fails
* Inspect service dependencies, discovering which services or device drivers depend on a given service or upon which services or device drivers a given service depends
* Export the list of services as a text file or as a [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) file

### Command line:
The [command-line](https://en.wikipedia.org/wiki/Command-line_interface) tool to manage Windows services is sc.exe. It is available for all versions of Windows NT. This utility is included with Windows XP[8] and later[9] and also in [ReactOS](https://en.wikipedia.org/wiki/ReactOS).

The sc command's scope of management is restricted to the local computer. However, starting with [Windows Server 2003](https://en.wikipedia.org/wiki/Windows_Server_2003), not only can sc do all that the Services snap-in does, but it can also install and uninstall services.
The sc command duplicates some features of the net command.
The ReactOS version was developed by Ged Murphy and is licensed under the [GPL](https://en.wikipedia.org/wiki/GNU_General_Public_License).



