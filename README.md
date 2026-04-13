# Shosetsu Template Repository

This repository is a template for creating new Shosetsu repositories.

## How to use this template

1. Create a new repository on GitLab or GitHub using this template (clone the repository and push it there)
2. Add your content to the appropriate directories:
   - `src/` for sources
   - `lib/` for libraries
   - `icons/` for icons
   - `styles/` for styles
3. Run `./test-server.sh` to build the index and host it locally
4. Add `http://<your ip>:8000` to Shosetsu's repository list
5. Test your new content in Shosetsu
6. If you are on GitHub, enable Pages and set the source to GitHub Actions
7. Commit and push your changes to the repository
8. The CI will automatically validate your repository and deploy it to Pages
9. Add your Pages URL to Shosetsu's repository list