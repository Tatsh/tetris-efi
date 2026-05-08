local utils = import 'utils.libjsonnet';

{
  uses_user_defaults: true,
  project_type: 'c',
  project_name: 'tetris-efi',
  version: '0.0.1',
  description: 'A Tetris clone that runs as a UEFI application.',
  keywords: ['efi', 'game', 'tetris', 'uefi'],
  want_main: false,
  want_codeql: false,
  want_tests: false, // Handled here not by Wiswa.
  want_winget: false,
  clang_format_args: 'src/*.c src/*.h tests/*.c',
  vscode+: {
    c_cpp+: {
      configurations: [
        {
          cStandard: 'gnu23',
          compilerArgs: ['-Wall', '-fno-stack-protector', '-fpic', '-fshort-wchar', '-mno-red-zone'],
          compilerPath: '/usr/bin/gcc',
          cppStandard: 'gnu++23',
          defines: ['EFI_FUNCTION_WRAPPER', 'GOP=1'],
          includePath: [
            '${default}',
            '${workspaceFolder}',
            '${workspaceFolder}/src',
            '/usr/include/efi/protocol',
            '/usr/include/efi/x86_64',
          ],
          name: 'Linux',
        },
      ],
    },
    launch+: {
      configurations: [
        {
          cwd: '${workspaceFolder}/build',
          name: 'test_piece',
          program: '${workspaceFolder}/build/tests/test_piece',
          request: 'launch',
          type: 'cppdbg',
        },
        {
          cwd: '${workspaceFolder}/build',
          name: 'test_game',
          program: '${workspaceFolder}/build/tests/test_game',
          request: 'launch',
          type: 'cppdbg',
        },
      ],
    },
    settings+: {
      'C_Cpp.default.includePath': [
        '/usr/include/efi',
        '/usr/include/efi/protocol',
        '/usr/include/efi/x86_64',
      ],
      'cmake.configureArgs': ['-DBUILD_TESTS=ON'],
    },
  },
}
