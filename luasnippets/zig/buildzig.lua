-- Return snippet tables
return {
  -- main file
  s(
    { trig = "addexe", snippetType = "autosnippet" },
    fmta(
      [[

        const <> = b.addExecutable(.{
            .name = "<>",
            .root_source_file = .{ .path = "src/<>.zig" },
            .target = target,
            .optimize = optimize,
        });

        b.installArtifact(<>);

        const run_cmd<> = b.addRunArtifact(<>);

        run_cmd<>.step.dependOn(b.getInstallStep());

      ]],
      {
        i(1),
        i(2),
        i(3),
        rep(1),
        i(4),
        rep(1),
        rep(4),
      }
    ),
    { condition = line_begin }
  ),
}
