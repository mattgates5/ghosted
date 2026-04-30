import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "toggle"]
  static values = { open: Boolean, storageKey: String }

  connect() {
    this.openValue = this.loadState()
    this.applyState()
  }

  toggle() {
    this.openValue = !this.openValue
    this.saveState()
    this.applyState()
  }

  applyState() {
    const content = this.contentTarget
    content.style.overflow = "hidden"
    if (this.openValue) {
      content.style.maxHeight = "2000px"
      content.style.opacity = "1"
    } else {
      content.style.maxHeight = "0"
      content.style.opacity = "0"
    }
    this.toggleTarget.textContent = this.openValue ? "▾ Hide" : "▸ Show"
  }

  loadState() {
    if (!this.storageKeyValue) return true
    const val = localStorage.getItem(this.storageKeyValue)
    return val === null ? true : val === "true"
  }

  saveState() {
    if (this.storageKeyValue) {
      localStorage.setItem(this.storageKeyValue, this.openValue)
    }
  }
}
