# Breadboard

[![Hex.pm](https://img.shields.io/hexpm/v/breadboard "Hex version")](https://hex.pm/packages/breadboard)
![GitHub](https://img.shields.io/github/license/henrythebuilder/breadboard)

`Breadboard` is an Elixir library developed to `breadboarding` with a single-board computer as simple as possible (this is the initial purpose).

All started using `Circuits.GPIO` on an [OrangePi PC board](http://www.orangepi.org/orangepipc/), all work fine but use GPIOs is not simple beacause of the logical pin numeration.

For example work on the pin ***12*** in the develop machine (without GPIOs) and in the OrangePi PC (pin label `PD14`) imply work in different way because in the board may be open the `logical pin` ***110*** in the sysfs user space !

Starting from here the idea to try to simplify the access to pinout information.


## Manage the pinout map
The module to manage the pinout information for the [supported platform](#supported-platform) is `Breadboard.Pinout`

Any pin is identify by the `pin number`, a `pin key`, a `pin label` and the `pin name`.

As example the pin ***12*** can be referenced by the `pin number` or the `pin key`:

```
Breadboard.Pinout.label_to_pin(12)
Breadboard.Pinout.label_to_pin(:pin12)
```

for any platform in a trasparent way, but the return value change from ***12*** to ***110*** according to the defined platform.

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

## Breadboard tools

### Pinout Mapping
In order to semplify the integration of other platform pinout mapping two module are defined to expand the `Breadboard` library: `Breadboard.GPIO.BaseGPIO` and `Breadboard.GPIO.BaseGPIOHelper`.

Module documentation explain also how GPIOs pinout mapping is made for a specific platform.

### Play on GPIOs
The first module develop to play on GPIOs is the `Breadboard.Switch` module.

This module handle the feature of `Circuits.GPIO` to manage the operation on GPIOs with the support of `Breadboard.Pinout`:

```
iex> {:ok, switch} = Breadboard.Switch.connect([pin: :gpio18, direction: :output])
iex> 18 = Breadboard.Switch.pin_number(switch)
iex> Breadboard.Switch.turn_on(switch)
iex> 1 = Breadboard.Switch.get_value(switch)
```

Check the `Breadboard.Switch` module documentation for more information.

## Breadboarding Environment

### "stub" hardware abstraction layer
`Circuits.GPIO` supports a "stub" hardware abstraction layer on platforms without GPIO support but as dependecy project this feature may not be present.

It's possible to enable the "stub" on Linux by setting `CIRCUITS_MIX_ENV` environment variable to `test`.

### Project Unit Test
Specific platform test are 'tagged' in order to execute, by default, only the test on the corrispondent platform.

Into the module documentation a check on platform is performed to exclude inappropriate test on different platform.

More details in the *project test files* and the example explained in the *module documentation*.

### Supported Platform
The platform is identified by the "`breadboard_platform`" environment variable as explained in the `Breadboard` module.

This value is used to map the pins for the specific plaform.

Platform supported are:

* ***stub*** -> a "stub" hardware abstraction layer as defined in `Circuits.GPIO`
* ***sunxi*** -> the family of ARM SoCs from Allwinner Technology


### Tested board
- [***OrangePi PC board***](http://www.orangepi.org/orangepipc/)
- [***OrangePi PC2 board***](http://www.orangepi.org/orangepipc2/)


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `breadboard` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:breadboard, "~> 0.0.3"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/breadboard](https://hexdocs.pm/breadboard).

## Author

Copyright © 2019 Enrico Rivarola

## License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[https://spdx.org/licenses/Apache-2.0.html](https://spdx.org/licenses/Apache-2.0.html)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


---
Note:

Individual files contain the following tag instead of the full license text:

`SPDX-License-Identifier: Apache-2.0`

Use *SPDX short-form identifiers* enables machine reading/processing of software information as defined in [Software Package Data Exchange® (SPDX®)](https://spdx.org)


*Check [NOTICE](NOTICE) and [LICENSE](LICENSE) project files for more information.*

---


SPDX-License-Identifier: Apache-2.0
