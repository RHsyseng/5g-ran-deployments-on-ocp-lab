// Execute when the DOM is fully loaded
document.addEventListener('DOMContentLoaded', function() {
    // Set the iframe sources using the SERVER_URL variable
    document.getElementById("terminal_01").src = `${SERVER_URL}/wetty/`;
    document.querySelector("#firefox_tab iframe").src = `${SERVER_URL}/firefox/`;
    
    // Open the default tab
    document.getElementById("defaultOpen").click();

    // Initialize Split.js with 50/50 split for both panes
    Split(['.left', '.right'], {
        sizes: [50, 50],
    });

    // If the vertical split is being used (from the original tabs.js)
    if (document.querySelector('.top') && document.querySelector('.bottom')) {
        Split(['.top', '.bottom'], {
            sizes: [65, 35],
            direction: 'vertical',
        });
    }
});

// Refresh tab to avoid issues with kasmvnc
document.addEventListener("visibilitychange", () => {
    if (!document.hidden) {
        const iframe = document.querySelector("#firefox_tab iframe");
        iframe.src = iframe.src;
    }
});

// Counter to keep track of terminal tabs
let terminalCounter = 1;

// Function to add a new terminal tab
function addNewTerminal() {
    terminalCounter++;

    // Get the tab buttons container and remove the current new terminal button
    const tabButtons = document.querySelector(".tab-buttons");
    const oldNewTerminalBtn = document.querySelector(".new-terminal-btn");
    tabButtons.removeChild(oldNewTerminalBtn);

    // Create the new tab button
    const newTabButton = document.createElement("button");
    newTabButton.className = "tablinks";
    newTabButton.tabIndex = terminalCounter;
    newTabButton.setAttribute("onclick", `openTerminal(event, 'terminal_tab_${terminalCounter}')`);
    //newTabButton.onclick = function(e) { openTerminal(e, `terminal_tab_${terminalCounter}`); };
    newTabButton.innerHTML = `Terminal ${terminalCounter} <span class="close-tab" onclick="closeTerminal(event, 'terminal_tab_${terminalCounter}')">✕</span>`;
    tabButtons.appendChild(newTabButton);

    // Add the new terminal button after the new tab
    const newTerminalBtn = document.createElement("button");
    newTerminalBtn.className = "new-terminal-btn";
    newTerminalBtn.innerHTML = "+ New Terminal";
    newTerminalBtn.onclick = addNewTerminal;
    tabButtons.appendChild(newTerminalBtn);

    // Create the new tab content container
    const rightPane = document.querySelector(".split.right");
    const newTabContent = document.createElement("div");
    newTabContent.id = `terminal_tab_${terminalCounter}`;
    newTabContent.className = "tabcontent";

    // Create the new terminal iframe
    const newIframe = document.createElement("iframe");
    newIframe.id = `terminal_0${terminalCounter}`;
    newIframe.src = `${SERVER_URL}/wetty/`;
    newIframe.width = "100%";
    newIframe.style.border = "none";

    // Append the iframe to the tab content
    newTabContent.appendChild(newIframe);
    rightPane.appendChild(newTabContent);

    // Activate the new tab
    openTerminal({ currentTarget: newTabButton }, `terminal_tab_${terminalCounter}`);

    // Scroll to the new tab button
    newTerminalBtn.scrollIntoView({ behavior: 'smooth', block: 'nearest', inline: 'end' });
}

// Function to close a terminal tab
function closeTerminal(event, tabId) {
    event.stopPropagation();

    // If the tab is a hardcoded tab, don't do anything
    if (tabId === 'firefox_tab') {
        return;
    }

    // Get the tab button and tab content
    const tabButton = event.target.parentElement;
    const tabContent = document.getElementById(tabId);

    // Check if this is the last tab
    const tabButtons = document.querySelectorAll(".tablinks");
    if (tabButtons.length <= 1) {
        // If it's the last tab, don't remove it
        return;
    }

    // Get the new terminal button
    const newTerminalBtn = document.querySelector(".new-terminal-btn");

    // Get the next or previous tab to activate
    let nextTab = tabButton.nextElementSibling;
    if (!nextTab || nextTab === newTerminalBtn) {
        nextTab = tabButton.previousElementSibling;
    }

    // Remove the tab button and content
    tabButton.parentElement.removeChild(tabButton);
    tabContent.parentElement.removeChild(tabContent);

    // Make sure the new terminal button is still the last element
    const tabButtonsContainer = document.querySelector(".tab-buttons");
    tabButtonsContainer.appendChild(newTerminalBtn);

    // Activate the next available tab
    if (nextTab && nextTab.classList.contains('tablinks')) {
        nextTab.click();
    }
}

// Function to open a terminal tab
function openTerminal(evt, terminalId) {
    // Declare all variables
    var i, tabcontent, tablinks;

    // Get all elements with class="tabcontent" and hide them
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }

    // Get all elements with class="tablinks" and remove the class "active"
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }

    // Show the current tab, and add an "active" class to the button that opened the tab
    document.getElementById(terminalId).style.display = "block";
    evt.currentTarget.className += " active";
}
