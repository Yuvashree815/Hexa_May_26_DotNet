# Departures Board

## Overview
This project simulates an airport departures board using JavaScript DOM manipulation.

## Features
- Dynamic flight rendering from an array of objects
- Live clock
- Add Departure button
- Reset Board button
- Automatic status updates
- Live statistics counter

## DOM Manipulation
All rows and cells are created using:
- document.createElement()
- textContent
- appendChild()

No flight rows exist in the HTML initially.

## Challenges
Managing live status updates while updating only the affected DOM elements instead of rerendering the entire board.