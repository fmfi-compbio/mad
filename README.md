# mad
Webpage of Data Management course


**<https://fmfi-compbio.github.io/mad>**

# How to update webpage

* Individual lectures and other text material are in folder [`notes`](./notes) in Markdown format wich is converted to html
* Images, pdf files, zip files etc are in folder [`data`](./data)
* File [`index.md`](./index.md) contains part of the main page but the schedule with links to lectures etc is created by macros in [`_includes/semester.html`](./_includes/semester.html) based on a data in file [`_data/semester.yaml`](./_data/semester.yaml)
* Announcements displayed at the top of each page are written in file [`_data/notes.yml`](./_data/notes.yml)
* Overall page layout is in [`_layouts/default.html`](./_layouts/default.html)
* Shared parts of pages are in [`_includes/head.html`](./_includes/head.html) (html head including styles), [`_includes/header.html`](./_includes/header.html) (top of the page including the menu and annoucements) and [`_includes/footer.html`](./_includes/footer.html) (bottom of the page).
* [`_config.yml`](./_config.yml) contains configuration including academic year which should be updated

* You can edit the files in github web interface or clone the repository to your computer, edit it there and then push the changes to the main branch
* After push, GitHub Actions are executed to run Jekyll framework which converts webpage to static HTML. The HTML files are then copied to the web. It takes several minutes for this to happen. You can view progress in Action tab. In case of a failed run you can also search for error messages there.

## Custom macros

* `{% include figure.html src="name.png" caption="Some caption" width="100px" %}` will add a figure with a caption. The file should be in [`files`](./files) folder. The `width` argument is optional. The figure can be made floating using `<div class="float-right">...</div>`.
*  [`_data/semester.yaml`](./_data/semester.yaml) contains several weeks, each week given by the dates, content and a list of items (can be empty).
  * Items have field `type` which can be `notes` if it is an `.md` file in `notes` folder, or `file` if it is a file in `files` folder, `text` for just a text or `url` for a link to external website
  * Field `name` of an item is the visible text
  * Field `file` is the filename. For notes, extension `.md` is added automatically, but for files it should be included. For URL the full URL should be given here. For type `text`, this field is ignored.


## Documentation

- Yekyll: https://jekyllrb.com/docs/
- Bootstrap: https://getbootstrap.com/docs/4.0/getting-started/introduction/
- Markdown: https://docs.github.com/en/get-started/writing-on-github
- Github pages: https://docs.github.com/en/pages
- YAML: https://yaml.org/spec/1.2.2/

Other useful docs:
* https://shopify.github.io/liquid/
* https://jekyllrb.com/docs/liquid/
* https://jekyllrb.com/docs/includes/
* {% if false %} (% endif %}
