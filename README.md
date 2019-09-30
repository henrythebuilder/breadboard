# Breadboard

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `breadboard` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:breadboard, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/breadboard](https://hexdocs.pm/breadboard).

## Environment variable
### Platform
Thi value is used to map the pins for the specific plaform.
Platform supported are:

* `stub` a "stub" hardware abstraction layer as defined in `Circuits.GPIO`
* `sunxi` the family of ARM SoCs from Allwinner Technology

The platform is identified by the "`breadborad_platform`" variable checked in the app's environment, in the system environment and finally as default value (`stub`) in this order.

### Test note for used platform
In order to execute all the test for any platform single test module are run serially (`async: flase`) and the platform is set for any test by the API `Breadboard.set_platform`


## License

Bradboard source code is released under Apache License 2.0.

Check [NOTICE](NOTICE) and [LICENSE](LICENSE) files for more information.
