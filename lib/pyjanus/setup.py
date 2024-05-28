# pylint: disable=missing-module-docstring,import-error

import setuptools

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

with open("requirements.txt", "r", encoding="utf-8") as requirements_file:
    requirements_text = requirements_file.read()

requirements = requirements_text.split()

setuptools.setup(
    name="pyJanus",
    version="0.1.1",
    author="Jaremy Hatler",
    author_email="hatler.jaremy@gmail.com",
    description="Just Another Neural Utility System",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/jhatler/janus",
    classifiers=[
        "Programming Language :: Python :: 3",
        "Operating System :: OS Independent",
    ],
    package_dir={"pyjanus": "lib/pyjanus"},
    entry_points={"console_scripts": ["janus = pyjanus:main"]},
    install_requires=requirements,
    packages=setuptools.find_packages(where="pyjanus"),
    python_requires=">=3.10",
)
