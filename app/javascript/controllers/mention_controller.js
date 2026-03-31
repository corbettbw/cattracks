import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown"]

  connect() {
    this.triggerChar = null
    this.triggerIndex = null
  }

  onInput(event) {
    const input = this.inputTarget
    const value = input.value
    const cursor = input.selectionStart

    // Look backwards from cursor for a trigger character
    let triggerChar = null
    let triggerIndex = null

    for (let i = cursor - 1; i >= 0; i--) {
      if (value[i] === "@" || value[i] === "$") {
        triggerChar = value[i]
        triggerIndex = i
        break
      }
      // Stop if we hit a space before finding a trigger
      if (value[i] === " " || value[i] === "\n") break
    }

    if (!triggerChar) {
      this.hideDropdown()
      return
    }

    const query = value.slice(triggerIndex + 1, cursor)
    if (query.length === 0) {
      this.hideDropdown()
      return
    }

    this.triggerChar = triggerChar
    this.triggerIndex = triggerIndex

    const endpoint = triggerChar === "@"
      ? `/autocomplete/users?q=${encodeURIComponent(query)}`
      : `/autocomplete/cats?q=${encodeURIComponent(query)}`

    fetch(endpoint)
      .then(r => r.json())
      .then(results => {
        if (results.length === 0) {
          this.hideDropdown()
          return
        }
        this.showDropdown(results)
      })
  }

  showDropdown(results) {
    const dropdown = this.dropdownTarget
    dropdown.innerHTML = ""
    results.forEach(item => {
      const div = document.createElement("div")
      div.className = "px-3 py-2 text-sm cursor-pointer hover:bg-amber-50"
      div.textContent = item.name
      div.addEventListener("mousedown", (e) => {
        e.preventDefault()
        this.insertMention(item.name)
      })
      dropdown.appendChild(div)
    })
    dropdown.classList.remove("hidden")
  }

  hideDropdown() {
    this.dropdownTarget.classList.add("hidden")
    this.dropdownTarget.innerHTML = ""
    this.triggerChar = null
    this.triggerIndex = null
  }

  insertMention(name) {
    const input = this.inputTarget
    const cursor = input.selectionStart
    const value = input.value
    const before = value.slice(0, this.triggerIndex)
    const after = value.slice(cursor)
    const mention = this.triggerChar + name + " "
    input.value = before + mention + after
    const newCursor = before.length + mention.length
    input.setSelectionRange(newCursor, newCursor)
    input.focus()
    this.hideDropdown()
  }

  onKeydown(event) {
    if (event.key === "Escape") this.hideDropdown()
  }
}