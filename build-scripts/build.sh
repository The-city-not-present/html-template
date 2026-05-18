#!/usr/bin/env bash
set -e

# pushd ..

echo "Clear up \"compiled/\"..."

mkdir -p compiled
rm -rf compiled
mkdir -p compiled
echo "done"
echo -
echo -

echo "Init python"
source .venv/bin/activate

echo "Produce \"normalize.css\""
python build.py --program build --resource "normalize.css" --dest "./compiled/"
echo "done"
echo -
echo -

echo "Produce \"css\""
python build.py --program build --resource "css" --dest "./compiled/"
echo "done"
echo -
echo -

echo "Produce \"js\""
python build.py --program build --resource "js" --dest "./compiled/"
echo "done"
echo -
echo -

echo "Produce \"html_bundle.py\""
echo "pre-make compiled html template within src folder"
if [ ! -d "./src/TEMPLATE_COMPILED" ]; then
  mkdir -p "./src/TEMPLATE_COMPILED"
fi
python build.py --program build --resource "src_template" --dest "./src/TEMPLATE_COMPILED/"
echo "Calling pinliner..."
# if [ ! -f "src-make/lib/pinliner/pinliner/pinliner.py" ]; then
#   # TODO: confirm is having --remote fine? I think it is. It's something like apt update, it is normal to run this occasionally. I don't see an issue
#   git submodule update --init --recursive --remote
# fi
# comment: please delete .pyc files before every call of the html_bundle - this is implemented in my fork of the pinliner
# python src-make/lib/pinliner/pinliner/pinliner.py src -o compiled/html_bundle.py --verbose
python "src-make/lib/pinliner/pinliner/pinliner.py" src -o compiled/html_bundle.py
echo "done"
echo "Patching html_bundle.py..."
echo "# ..." >> "compiled/html_bundle.py"
echo "# print('within html_bundle')" >> "compiled/html_bundle.py"
# no need for this, the root package is loaded automatically
# echo "# import html_bundle" >> "compiled/html_bundle.py"
echo "from src import make_html" >> "compiled/html_bundle.py"
echo "# make_html.main()" >> "compiled/html_bundle.py"
echo "# print('out of html_bundle')" >> "compiled/html_bundle.py"
echo "done"
echo -
echo -
python build.py --program done

deactivate

# popd
