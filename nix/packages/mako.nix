{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.mako = (
        inputs.wrappers.wrappers.mako.wrap {
          inherit pkgs;
          settings = {
            actions = true;
            anchor = "top-right";
            background-color = "#1e1e2e";
            border-color = "#cdd6f4";
            border-radius = 8;
            border-size = 3;
            font = "monospace 13.5";
            icons = 1; # Show icons in notifications
            margin = 3;
            padding = 13;
            progress-color = "over #313244";
            text-color = "#cdd6f4";
            "urgency=high" = {
              border-color = "#fab387";
            };
          };
        }
      );
    };
}
