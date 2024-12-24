# Define the interface name.
:local interfaceName "<Session_name>"

# Find the interface ID of the SSTP Client interface.
:local interfaceID [/interface sstp-client find where name=$interfaceName]

# Check if the interface exists.
:if ($interfaceID != "") do={
  :local interfaceRunning [/interface sstp-client get $interfaceID running]

  :if ($interfaceRunning = "true") do={
    # If the interface is active, disable it.
    /interface sstp-client disable $interfaceID
    :put ("The SSTP Client interface " . $interfaceName . " has been disabled.")
  } else={
    # If the interface is not active, enable it.
    /interface sstp-client enable $interfaceID
    :put ("The SSTP Client interface " . $interfaceName . " has been enabled.")
  }

  # Delay for a few seconds before enabling the interface again.
  :delay 5s

  # Enable the interface.
  /interface sstp-client enable $interfaceID
  :put ("The SSTP Client interface " . $interfaceName . " has been restarted.")
} else {
  # If the interface does not exist, display a message.
  :put ("The specified SSTP Client interface " . $interfaceName . " does not exist.")
}
