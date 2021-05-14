#!/bin/sh

Name="${Name:-"OpenRA Dedicated Server - @title@"}"
ListenPort="${ListenPort:-"1234"}"
AdvertiseOnline="${AdvertiseOnline:-"True"}"
Password="${Password:-""}"

RequireAuthentication="${RequireAuthentication:-"False"}"
ProfileIDBlacklist="${ProfileIDBlacklist:-""}"
ProfileIDWhitelist="${ProfileIDWhitelist:-""}"

EnableSingleplayer="${EnableSingleplayer:-"False"}"
EnableSyncReports="${EnableSyncReports:-"False"}"

mono --debug OpenRA.Server.exe \
  Game.Mod=@name@ \
  Engine.LaunchPath="@out@/bin/openra-@name@" \
  Engine.ModSearchPaths="@out@/lib/openra-@name@/mods" \
  Server.Name="$Name" \
  Server.ListenPort="$ListenPort" \
  Server.AdvertiseOnline="$AdvertiseOnline" \
  Server.EnableSingleplayer="$EnableSingleplayer" \
  Server.Password="$Password" \
  Server.RequireAuthentication="$RequireAuthentication" \
  Server.ProfileIDBlacklist="$ProfileIDBlacklist" \
  Server.ProfileIDWhitelist="$ProfileIDWhitelist" \
  Server.EnableSyncReports="$EnableSyncReports" \
 "$@"
