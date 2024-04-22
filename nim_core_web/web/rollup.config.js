import typescript from 'rollup-plugin-typescript2'
import commonjs from '@rollup/plugin-commonjs'
import { terser } from 'rollup-plugin-terser'
import { nodeResolve } from '@rollup/plugin-node-resolve'
import json from '@rollup/plugin-json'

const isDev = process.env.DEV

export default {
  input: './src/index.ts',
  output: [
    {
      file: './dist/index.umd.js',
      name: 'FlutterWeb',
      format: 'umd',
      exports: 'named',
      plugins: [!isDev && terser()],
    },
    {
      file: './dist/index.esm.js',
      format: 'esm',
      exports: 'named',
      plugins: [!isDev && terser()],
    },
    {
      file: './dist/index.cjs.js',
      format: 'cjs',
      exports: 'named',
      plugins: [!isDev && terser()],
    },
  ],
  plugins: [
    typescript({
      tsconfig: './tsconfig.json',
      useTsconfigDeclarationDir: true,
    }),

    nodeResolve({
      mainFields: ['jsnext', 'preferBuiltins', 'browser'],
    }),

    commonjs(),

    json(),
  ],
}
