import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input" ]

  connect() {
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition
    if (SpeechRecognition) {
      this.recognition = new SpeechRecognition()
      this.recognition.continuous = false
      this.recognition.lang = 'en-US'

      this.recognition.onresult = (event) => {
        const transcript = event.results[0][0].transcript
        this.inputTarget.value = transcript
        this.element.classList.remove("recording")
      }

      this.recognition.onend = () => {
        this.element.classList.remove("recording")
      }
    }
  }

  record(event) {
    event.preventDefault()
    if (!this.recognition) {
      alert("Mic recognition not supported in this browser.")
      return
    }

    if (this.element.classList.contains("recording")) {
      this.recognition.stop()
    } else {
      this.element.classList.add("recording")
      this.recognition.start()
    }
  }
}
