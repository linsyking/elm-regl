# Elm-regl

Elm bindings for [regl](https://github.com/regl-project/regl).

Aims to provide a set of declarative APIs to use WebGL in Elm through regl.

## Design

In Elm, we provide data structures and a `compile` API to form a sequence of drawing commands.

### Effect-Composite Pattern

Use effects to apply shaders to one group, use compositors to composite two groups.

### Renderable

- A Program ID corresponding to a GL program pre-compiled.
- Configurations. (Key Value Pair)

### GL Program

Vertex + Fragment shader programs.

Geometry + uniforms.


### TODO

Optimize `Encode.object`. It's currently too slow.
