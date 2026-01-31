{ ... }:
{
  security = {
	  sudo = {
	    enable = true;
	    wheelNeedsPassword = true;
	    execWheelOnly = true;
    };
	  polkit.enable = true;
  };
}
