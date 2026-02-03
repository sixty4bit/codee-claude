# LLAPP Context

## What It Is

LLAPP (Leverage Leadership App) is a Rails application that helps school leaders plan meetings using AI-generated materials.

## Core Features

- **Planning Wizards** — Conversational flow to collect materials for meetings
- **Document Processing** — Upload DOCX files, extract content, process with LLM
- **Product Generation** — Know-Show charts, Gap Analysis, Reteach materials
- **Knowledge Base** — Guides and exemplars that inform LLM prompts

## Planning Types

| Type | Class | Purpose |
|------|-------|---------|
| Weekly Data Meeting | `Planning::WeeklyDataMeeting` | Analyze student work data |
| Weekly Planning Meeting | `Planning::WeeklyPlanningMeeting` | Plan upcoming instruction |
| Observation & Feedback | `Planning::ObservationFeedbackMeeting` | Post-observation coaching |
| Professional Development | `Planning::ProfessionalDevelopmentMeeting` | PD session planning |

## Key Jobs

- `GenerateWdmProductsJob` — Generates WDM products (know-show, gap, reteach)
- `GenerateWpmProductsJob` — Generates WPM products
- `ProcessPlanningChunkJob` — Processes uploaded documents

## Tech Stack

- Rails 8.1 with HAML views
- Hotwire/Turbo for real-time updates
- Bootstrap 5 for styling
- SolidQueue for background jobs
- RubyLLM gem for OpenAI integration
- gpt-5.2 as default model

## Conventions

- **No Tailwind** — Bootstrap only
- **No ERB** — HAML for all views (except mailers)
- **No React/Vue** — Hotwire/Stimulus for JS
- **TDD** — Tests before implementation
- **PRs to main** — Always target main unless told otherwise

## Current State

- Services run as LaunchAgents (see TOOLS.md)
- Local: http://localhost:3077
- Public: https://llappy.ngrok.app
