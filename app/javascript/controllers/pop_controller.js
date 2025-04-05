import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['pop', 'icon']

    toggle() {
        this.popTarget.classList.contains('active') ? this.iconTarget.innerHTML = '<i class="far fa-plus"></i>' : this.iconTarget.innerHTML = '<i class="far fa-minus"></i>';
        this.popTarget.classList.toggle('active');
    }
}