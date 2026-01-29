import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card", "city", "sector", "revenue"]

  apply() {
    const city = this.cityTarget.value
    const sector = this.sectorTarget.value
    const revenue = this.revenueTarget.value

    this.cardTargets.forEach(card => {
    
      const matchCity = city === "" || card.dataset.city === city
      const matchSector = sector === "" || card.dataset.sector === sector
      const matchRevenue = revenue === "" || card.dataset.revenue === revenue


      if (matchCity && matchSector && matchRevenue) {
        card.style.display = "flex"
      } else {
        card.style.display = "none"
      }
    })
  }
}
