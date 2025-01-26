#!/usr/bin/env bash

if [ ! -f /usr/share/X11/xkb/symbols/real-prog-dvorak ]; then
    echo "real-prog-dvorak doesn't exist, copying over"
    cp ./resources/real-prog-dvorak /usr/share/X11/xkb/symbols
fi

if [ ! -f /usr/share/X11/xkb/symbols/real-prog-dvo-k ]; then
    echo "real-prog-dvo-k doesn't exist, copying over"
    cp ./resources/real-prog-dvo-k /usr/share/X11/xkb/symbols
fi

if grep -q "real-prog-dvorak" /usr/share/X11/xkb/rules/evdev.xml && \
   grep -q "real-prog-dvo-k" /usr/share/X11/xkb/rules/evdev.xml; then
    echo "evdev.xml already has both real-prog-dvorak and real-prog-dvo-k layout definitions"
    exit 0
fi

dvorak_env="
<layout>
      <configItem>
        <name>real-prog-layout</name>
        <shortDescription>epd</shortDescription>
        <description>Prime English (US)</description>
      </configItem>
      <variantList>
    <variant>
        <configItem>
            <name>real-prog-dvorak</name>
            <description>English (Real Programmers Dvorak)</description>
            <vendor>MichaelPaulson</vendor>
        </configItem>
    </variant>
    <variant>
        <configItem>
            <name>real-prog-dvo-k</name>
            <description>English (Real Programmers Dvorak Kinesis Remapped)</description>
            <vendor>MichaelPaulson</vendor>
        </configItem>
    </variant>
      </variantList>
</layout>
"

layout_list=$(grep -n "<layoutList>" /usr/share/X11/xkb/rules/evdev.xml | cut -f1 -d:)
total_lines=$(wc -l < /usr/share/X11/xkb/rules/evdev.xml)
tail_lines=$((total_lines - layout_list))

up_to=$(head -n "$layout_list" /usr/share/X11/xkb/rules/evdev.xml)
remaining=$(tail -n "$tail_lines" /usr/share/X11/xkb/rules/evdev.xml)

echo "$up_to
$dvorak_env
$remaining
" > /usr/share/X11/xkb/rules/evdev.xml

echo "Don't forget to log out to let these changes take effect."
