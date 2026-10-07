const agentCards = [...document.querySelectorAll(".agent-card")];
const filterButtons = [...document.querySelectorAll(".filter-button")];
const searchInput = document.querySelector("#agent-search");
const emptyState = document.querySelector("#empty-state");
const toast = document.querySelector("#toast");
const menuToggle = document.querySelector(".menu-toggle");
const mobileNav = document.querySelector("#mobile-nav");
let activeFilter = "all";
let toastTimer;

function filterAgents() {
  const searchTerm = searchInput.value.trim().toLowerCase();
  let visibleCount = 0;

  for (const card of agentCards) {
    const matchesCategory = activeFilter === "all" || card.dataset.category === activeFilter;
    const matchesSearch = card.dataset.search.includes(searchTerm) || card.textContent.toLowerCase().includes(searchTerm);
    const isVisible = matchesCategory && matchesSearch;
    card.hidden = !isVisible;
    visibleCount += Number(isVisible);
  }

  emptyState.hidden = visibleCount !== 0;
}

for (const button of filterButtons) {
  button.addEventListener("click", () => {
    activeFilter = button.dataset.filter;
    for (const filterButton of filterButtons) {
      const isActive = filterButton === button;
      filterButton.classList.toggle("active", isActive);
      filterButton.setAttribute("aria-pressed", String(isActive));
    }
    filterAgents();
  });
}

searchInput.addEventListener("input", filterAgents);

for (const button of document.querySelectorAll("[data-copy]")) {
  button.addEventListener("click", async () => {
    const code = document.getElementById(button.dataset.copy).textContent;
    try {
      await navigator.clipboard.writeText(code);
      toast.textContent = "Commands copied to clipboard";
    } catch {
      toast.textContent = "Clipboard unavailable. Select the commands to copy.";
    }
    toast.classList.add("visible");
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => toast.classList.remove("visible"), 2400);
  });
}

menuToggle.addEventListener("click", () => {
  const isExpanded = menuToggle.getAttribute("aria-expanded") === "true";
  menuToggle.setAttribute("aria-expanded", String(!isExpanded));
  menuToggle.setAttribute("aria-label", isExpanded ? "Open navigation" : "Close navigation");
  mobileNav.hidden = isExpanded;
});

mobileNav.addEventListener("click", (event) => {
  if (event.target.closest("a")) {
    mobileNav.hidden = true;
    menuToggle.setAttribute("aria-expanded", "false");
    menuToggle.setAttribute("aria-label", "Open navigation");
  }
});