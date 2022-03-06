const Hooks = {
    Flash: {
        mounted() {
            setTimeout(() => this.closeFlash(), 3000)
        },
        closeFlash() {
            this.pushEvent("lv:clear-flash")
        }
    }
}


export default Hooks;