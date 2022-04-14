import SimpleMDE from 'simplemde';
import { marked } from 'marked';

const Hooks = {
    Flash: {
        mounted() {
            setTimeout(() => this.closeFlash(), 3000)
        },
        closeFlash() {
            this.pushEvent("lv:clear-flash")
        }
    },
    Lang: {
        mounted() {
            this.el.addEventListener("change", (e) => {
                const parser = new URL(window.location);
                parser.searchParams.set('locale', e.target.value);
                window.location = parser.href;
            });
        }
    },
    ScrollOnUpdate: {
        updated() {
            this.el.scrollIntoView();
        }
    },
    MultiSelect: {
        mounted() {
            const listName = this.el.getAttribute('data-list');
            const input = this.el.querySelector('input');

            input.addEventListener('keyup', (event) => {
                let value = event.target.value;
                if (event.key === ',') {
                    value.split(',').filter(v => v).forEach(item => {
                        this.pushEvent('multiselect', {
                            list: listName,
                            item: {
                                id: item,
                                title: item
                            },
                            type: 'add'
                        });
                        event.target.value = '';
                    });
                }
            })
        }
    },
    Markdown: {
        mounted() {
            const simplemde = new SimpleMDE({
                element: this.el,
                previewRender: function (plainText) {
                    return marked(plainText); // Returns HTML from a custom parser
                },
            });


            let targetTextarea = this.getTarget(this.el.getAttribute('id'));

            simplemde.codemirror.on("change", function () {
                if (!targetTextarea) {
                    targetTextarea = this.getTarget(this.el.getAttribute('id'));
                }
                if (targetTextarea) {
                    targetTextarea.value = simplemde.value();
                }
            });
        },
        getTarget(id) {
            return document.querySelector(`textarea[data-id="target-${id}"]`);
        }
    }
}


export default Hooks;