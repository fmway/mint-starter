{ pkgs, lib, ... }: {
  name = "mint-starter";

  packages = with pkgs.unstable; [
    mint
    imagemagick
    static-web-server
  ];

  scripts = {
    build.exec = "mint build";
    instal.exec = "mint install";
    start.exec = "static-web-server --root ./dist --port 8080";
  };
}
