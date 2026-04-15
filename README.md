# mad

Webpage of Data Management course **<https://fmfi-compbio.github.io/mad>**

## File system overview

* Individual lectures and other text material are in folder [`notes`](./notes) in Markdown format wich is converted to html
* Images, pdf files, zip files etc are in folder [`data`](./data)
* File [`index.md`](./index.md) contains part of the main page but the schedule with links to lectures etc is created by macros in [`_includes/semester.html`](./_includes/semester.html) based on a data in file [`_data/semester.yaml`](./_data/semester.yaml)
* Announcements displayed at the top of each page are written in file [`_data/notes.yml`](./_data/notes.yml)
* Overall page layout is in [`_layouts/default.html`](./_layouts/default.html)
* Shared parts of pages are in [`_includes/head.html`](./_includes/head.html) (html head including styles), [`_includes/header.html`](./_includes/header.html) (top of the page including the menu and annoucements) and [`_includes/footer.html`](./_includes/footer.html) (bottom of the page).
* [`_config.yml`](./_config.yml) contains configuration including academic year which should be updated

## Updating the website

You can edit the files in GitHub web interface or clone the repository to your computer, edit it there and then push the changes to the `master` branch.

>[!TIP]
> If you clone and edit locally the webiste, you can use docker to check live changes, see [Live changes via docker](#live-changes-via-docker)

After push, GitHub Actions are executed to run Jekyll framework which converts webpage to static HTML. The HTML files are then copied to the web.
It takes several minutes for this to happen. You can view progress in Action tab.
In case of a failed run you can also search for error messages there.
In case of success, the website is available at <https://fmfi-compbio.github.io/mad>.

### Manage classes

[`_data/semester.yaml`](./_data/semester.yaml) contains several weeks, each week given by the dates, content and a list of items (can be empty).

* Items have field `type` which can be `notes` if it is an `.md` file in `notes` folder, or `file` if it is a file in `files` folder, `text` for just a text or `url` for a link to external website
* Field `name` of an item is the visible text
* Field `file` is the filename. For `notes`, extension `.md` is added automatically, but for files in the `./files` folder it should be included. For `url` the full URL should be given here. For type `text`, this field is ignored.

### Custom macros

#### Figure

```md
A figure with a caption:

{% include figure.html src="name.png" caption="Some caption" width="100px" %}
```

* The file should be in [`./files`](./files) folder.
* The `width` argument is optional.
* The figure can be made floating using `<div class="float-right">...</div>`.

#### Admonitions

As in GitHub <https://docs.github.com/fr/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts>.

```md
Simple admonitions:

{% include admonition.html type="info" content="Info." %}

{% include admonition.html type="tip" content="Tip." %}

{% include admonition.html type="important" content="Important." %}

{% include admonition.html type="warning" content="Warning." %}

{% include admonition.html type="danger" content="Danger." %}

Collapsing admonition:

{% include admonition.html type="tip" collapsible=true content="Hidden details here." %}

Multi-line content:

{% capture tipcontent %}
Markdown **works here**, including *formatting* and lists.

* item1
* item2

{% endcapture %}

{% include admonition.html type="tip" content=tipcontent %}
```

### Live changes via docker

If you have cloned this repository, you can build locally the website to check your updates.

Inpired by <https://jogendra.dev/dockerize-your-jekyll-site-for-local-development> and <https://mademistakes.com/mastering-jekyll/site-url-baseurl/>.

Launch the live server:

```bash
# The first time
docker compose up --build

# The next times (without building)
docker compose up
```

Stop the live server, `CTRL+C`, and then:

```bash
# Stop using the image
docker compose down

# Verify the image is not used
docker images # ukba-mad-jekyll:latest must not be used
```

If the docker image is still used:

```bash
docker container ls # to find the container id
docker container rm <container_id>
```

To make a clean build:

```bash
rm -rf _site
docker rmi ukba-mad-jekyll:latest
```

## Documentation

* Yekyll: <https://jekyllrb.com/docs/>
* Bootstrap: <https://getbootstrap.com/docs/4.0/getting-started/introduction/>
* Markdown: <https://docs.github.com/en/get-started/writing-on-github>
* Github pages: <https://docs.github.com/en/pages>
* YAML: <https://yaml.org/spec/1.2.2/>

Other useful docs:

* <https://shopify.github.io/liquid/>
* <https://jekyllrb.com/docs/liquid/>
* <https://jekyllrb.com/docs/includes/>
* `{% if false %} (% endif %}`
