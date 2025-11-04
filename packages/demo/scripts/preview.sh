#!/bin/bash

# Navigate to the demo directory (parent of scripts)
cd "$(dirname "$0")/.."

echo "🚀 Starting Remix Widget Preview..."
echo "📍 Running from: $(pwd)"
echo ""

# Check if Flutter is available
if ! command -v flutter &> /dev/null
then
    echo "❌ Flutter could not be found. Please ensure Flutter is installed and in your PATH."
    exit 1
fi

# Check Flutter version
echo "📋 Flutter Version:"
flutter --version | head -1

echo ""
echo "🔧 Starting widget preview server..."
echo "💡 This will open in Chrome browser automatically"
echo "📝 Available previews:"
echo "   • Accordion (Basic, with Icons, Pre-expanded, Rich Content)"
echo "   • Buttons (Basic, States, Icon-only, Variations)"  
echo "   • Cards (Basic, with Actions, Profile, Stats)"
echo "   • Form Components (Checkbox, Switch, Radio, TextField, Slider, Select)"
echo ""
echo "🛑 Press Ctrl+C to stop the preview server"
echo ""

# Start the widget preview
flutter widget-preview start