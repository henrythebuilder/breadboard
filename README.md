# Breadboard

`Breadboard` is an Elixir library developed to `breadboarding` with a single-board computer as simple as possible (this is the initial purpose).

All started using `Circuits.GPIO` on an [OrangePi PC board](http://www.orangepi.org/orangepipc/), all work fine but use GPIOs is not simple beacause of the logical pin numeration.

For example work on the pin 12 in the develop machine (without GPIOs) and in the OrangePi PC (pin label `PD14`) imply work in different way beacouse in the board may be open the `logical pin` 110 in the sysfs user space !

Starting from here the idea to try to simplify the access to pinout information.


## Manage the pinout map
The module to manage the pinout information for the [supported platform](#supported-platform) is `Breadboard.Pinout`

Any pin is identify by the `pin number`, a `pin key`, a `pin label` and the `pin name`

As example the pin 12 can be referenced by the `pin number` or the `pin key`:

```
Breadboard.Pinout.label_to_pin(12)
Breadboard.Pinout.label_to_pin(:pin12)
```

for any platform in a trasparent way, but the return value change from 12 to 110 according to the defined platform.

Same result can be obtained using the `pin name` or the `pin label` for the `stub` platform:
```
Breadboard.Pinout.label_to_pin("GPIO12")
Breadboard.Pinout.label_to_pin(:gpio12)
```

and for the specific OrangePi PC board:

```
Breadboard.Pinout.label_to_pin("PD14")
Breadboard.Pinout.label_to_pin(:pd14)
```

In a reverse way the `pin label` may be find by the `Breadboard.Pinout.label_to_pin/1` method:

```
Breadboard.Pinout.pin_to_label(12)
Breadboard.Pinout.pin_to_label(:pin12)
```

produce the `:gpio12` or `:pd14` based on the configured platform.


## Test environment

### "stub" hardware abstraction layer
`Circuits.GPIO` supports a "stub" hardware abstraction layer on platforms without GPIO support but as dependecy project this feature is disable on compilation. Setting MIX_ENV variable to 'test' during compilation is forced to 'prod' so test involving gpio fails to enable `stub` support.

At this time the only solution found on my *development pc* is to hack the makefile of `Circuits.GPIO` as [explained on GithHub](https://github.com/elixir-circuits/circuits_gpio/pull/61)

### Project Unit Test
Sigle test are 'tagged' to execute, by default' only the test on the corrispondent platform.

Into the documentation, to enable the 'test filter' a check on the platform is performed to exclude inappropriate test on wrong platform.

For more details the *project test files*


## Environment variable

### Supported Platform
This value is used to map the pins for the specific plaform.

Platform supported are:

* `stub` a "stub" hardware abstraction layer as defined in `Circuits.GPIO`
* `sunxi` the family of ARM SoCs from Allwinner Technology

The platform is identified by the "`breadboard_platform`" variable checked in the app's environment, in the system environment and finally as default value (`stub`) in this order.


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

## License

Copyright 2019 Enrico Rivarola

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


 *Check [NOTICE](NOTICE) and [LICENSE](LICENSE) project files for more information.*
