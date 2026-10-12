# Korotkina Showroom Assistants

Two sample Claude assistants for Alina Korotkina Fine Jewelry, packaged as one Claude plugin.

## Use it

- **custom-heirloom-inquiries**: paste a client's message about a custom piece or a family heirloom. Claude drafts a short, warm reply that suggests the right consultation and links the booking page, then a prep note for Alina (what is known, what is not, what she decides).
- **repair-inquiries**: paste a message about a repair, a resizing, a watch or a pickup. Claude drafts a reply that suggests the right appointment type, then an intake note.

Claude picks the right assistant from the message. Every reply is a draft: nothing is sent automatically, and the assistants never quote a price, a date or an availability.

## Data

The plugin contains only instructions. It sends nothing anywhere by itself; the messages you paste go to the model provider Claude is configured with (for example your own Amazon Bedrock account).

## Install

- Claude Desktop (Chat or Cowork): **Customize > Plugins**, upload `korotkina-coworkers-plugin.zip`, or add the marketplace `fred1433/korotkina-coworkers`.
- Claude Code: `/plugin install korotkina-coworkers --marketplace fred1433/korotkina-coworkers`
