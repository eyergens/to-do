import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  connect() {
      console.log(this.element);
  }
  toggle(e) {
      const id = e.target.dataset.id;
      const csrfToken = document.querySelector("[name='csrf-token']").content;
      let newStatus = e.target.checked;
      fetch(`/items/${id}/toggle`, {
          method: 'POST',
          mode: 'cors',
          cache: 'no-cache',
          credentials: 'same-origin',
          headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': csrfToken
          },
          body: JSON.stringify({ status: e.target.checked })
      })
        .then(response => response.json())
        .then(data => {
        if (data.message === true) {
          let itemElem = document.getElementById(id);

          if (newStatus) {
            itemElem.classList.add("completed");
            document.getElementById("completed-list").prepend(itemElem);
          } else {
            itemElem.classList.remove("completed");

            const activeContainer = document.getElementById("active-list");
            const itemOrder = parseFloat(itemElem.dataset.order);

            let inserted = false;
            const children = Array.from(activeContainer.querySelectorAll('.task-item'));
            for (let child of children) {
              let childOrder = parseFloat(child.dataset.order);
              if (itemOrder < childOrder) {
                activeContainer.insertBefore(itemElem, child);
                inserted = true;
                break;
              }
            }
            if (!inserted) {
              activeContainer.appendChild(itemElem);
            }
          }
        } else {
          console.error("Error toggling item:", data.errors);
        }
      })
  }
}