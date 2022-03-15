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
    }
}


export default Hooks;