#!/usr/bin/env python
# arguments: 1=Window ID, 2=Class, 3=Instance

import dataclasses
import re
import subprocess
import sys
from enum import Enum
from typing import Any, List, Optional, Type, TypeVar

T = TypeVar('T', bound='XProperty')

# Regular expressions for property extraction
rName = r'(?<=WM_NAME\(STRING\) = ").*(?=")'
rWmWindowRole = r'(?<=WM_WINDOW_ROLE\(STRING\) = ").*(?=")'
rNetWmWindowType = r'(?<=_NET_WM_WINDOW_TYPE\(ATOM\) = ).*(?=)'
rLocation = r'(?<=specified location: ).*(?=)'
rGravity = r'(?<=window gravity: ).*(?=)'

class Toggle(Enum):
    ON = 'on'
    OFF = 'off'

    def __str__(self) -> str: return self.value

class State(Enum):
    TILED = 'tiled'
    PSEUDO_TILED = 'pseudo'
    FLOATING = 'floating'
    FULLSCREEN = 'fullscreen'

    def __str__(self) -> str: return self.value

@dataclasses.dataclass
class Rule:
    monitor: str = ''
    desktop: str = ''
    node: str = ''
    state: State = State.TILED
    layer: str = ''
    honor_size_hints: str = ''
    split_dir: str = ''
    split_ratio: str = ''
    hidden: Toggle = Toggle.OFF
    sticky: Toggle = Toggle.OFF
    private: Toggle = Toggle.OFF
    locked: Toggle = Toggle.OFF
    marked: Toggle = Toggle.OFF
    center: Toggle = Toggle.OFF
    follow: Toggle = Toggle.OFF
    manage: Toggle = Toggle.OFF
    focus: Toggle = Toggle.OFF
    border: Toggle = Toggle.OFF
    rectangle: str = ''

    def __str__(self):
        return ' '.join(f'{key}={val}' for key, val in self.__dict__.items())

    def __getitem__(self, key):
        return self.__dict__[key]

    @classmethod
    def parse(cls, data: str) -> Self:
        values = {kv.split('=')[0]: kv.split('=')[1] for kv in data.split(' ')}
        return cls(**values)

class XProperty:
    def __init__(self, xprop: str):
        self.name = self.search(rName, xprop)
        self.gravity = self.search(rGravity, xprop)
        self.location = self.search(rLocation, xprop)
        self.window_role = self.search(rWmWindowRole, xprop)
        window_type = self.search(rNetWmWindowType, xprop)
        self.window_type = window_type.split(', ') if window_type else []

    @classmethod
    def xprop(cls: Type[T], wid: str) -> T:
        output = subprocess.check_output(['xprop', '-id', wid]).decode('utf-8')
        return cls(output)

    def search(self, regexp: str, text: str) -> Optional[str]:
        match = re.search(regexp, text)
        return match.group(0) if match else None

    def is_dialog(self) -> bool:
        return '_NET_WM_WINDOW_TYPE_DIALOG' in self.window_type

    def is_floating(self) -> bool:
        return '_NET_WM_WINDOW_TYPE_SPLASH' in self.window_type

    def apply(self, rule: Rule) -> Rule:
        if self.is_floating() or self.is_dialog():
            rule.state = State.FLOATING
            rule.border = Toggle.ON if self.is_dialog() else Toggle.OFF

        if self.window_role == 'Popup':
            rule.border = Toggle.OFF
            rule.manage = Toggle.OFF
        elif self.window_role == 'toolbox':
            rule.state = State.FLOATING

        return rule

if __name__ == '__main__':
    try:
        rule = Rule.parse(sys.argv[4])
        new_rule = XProperty.xprop(sys.argv[1]).apply(Rule(**rule.__dict__))

        rules = [f'{k}={new_rule[k]}' for k in rule.__dict__.keys() if rule[k] != new_rule[k]]
        print(' '.join(rules))
    except Exception as e:
        with open("/tmp/external_rules.log", "a+") as f:
            f.write(f'{e}\n')