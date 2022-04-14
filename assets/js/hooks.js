import Mde from 'easymde';

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
            const mde = new Mde({
                element: this.el,
                uploadImage: true,
                imageUploadFunction: (file, s, e) => {
                    console.log('file : ', file)
                }
            });


            let targetTextarea = this.getTarget(this.el.getAttribute('id'));

            mde.codemirror.on("change", function () {
                if (!targetTextarea) {
                    targetTextarea = this.getTarget(this.el.getAttribute('id'));
                }
                if (targetTextarea) {
                    targetTextarea.value = mde.value();
                }
            });
        },
        getTarget(id) {
            return document.querySelector(`textarea[data-id="target-${id}"]`);
        }
    }
}


export default Hooks;