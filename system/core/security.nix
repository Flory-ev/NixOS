{ ... }:
{
  security = {
		polkit.enable = true;

	  sudo = {
	    enable = true;
	    wheelNeedsPassword = true;
	    execWheelOnly = true;
    };
  };
}
