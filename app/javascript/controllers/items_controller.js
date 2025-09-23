import { Controller } from "@hotwired/stimulus";
import { getCSRFToken } from "../global";
export default class extends Controller {
  connect() {
      console.log(this.element);
  }
  toggle(e) {
      const id = e.target.dataset.id;
      let newStatus = e.target.checked;
      fetch(`/items/${id}/toggle`, {
          method: 'PATCH',
          mode: 'cors',
          cache: 'no-cache',
          credentials: 'same-origin',
          headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': getCSRFToken()
          },
          body: JSON.stringify({ status: e.target.checked })
      })
        .then(response => response.json())
        .then(data => {
        if (data.status === true) {
          let itemElem = document.getElementById(id);
          let updated_time = document.getElementById('updated_time_' + id);
          updated_time.innerHTML = data.message;

          if (newStatus) {
            this.completedTask(itemElem)
          } else {
            this.activeTask(itemElem)
          }
        } else {
          console.error("Error toggling item:", data.errors);
        }
      })
  }

  completedTask(itemElem) {
    let url = new URL(window.location.href);
    if (url.searchParams.has('show_completed')) {
      // Insert element to the top of the completed list
      itemElem.classList.add("completed");
      document.getElementById("completed_list").prepend(itemElem);
    } else {
      itemElem.remove();
    }
  }

  activeTask(itemElem) {
    itemElem.classList.remove("completed");

    const activeContainer = document.getElementById("active_list");
    const itemOrder = parseFloat(itemElem.dataset.order);

    // Insert the element into the active list based on its order
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
      // Insert the element to the bottom of the active list
      activeContainer.appendChild(itemElem);
    }
  }
}