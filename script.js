// script.js — simple builder for demo cards
document.addEventListener("DOMContentLoaded", function(){
  const cards = document.getElementById("cards");
  for(let i=1;i<=6;i++){
    const card = document.createElement("div");
    card.className = "card";
    const img = document.createElement("div"); img.className = "img";
    const h3 = document.createElement("h3"); h3.textContent = `Script ${i}`;
    const p = document.createElement("p"); p.textContent = "Grow A Garden / Utility script placeholder. UI-only preview.";
    const actions = document.createElement("div"); actions.className = "actions";
    const use = document.createElement("button"); use.className = "btn"; use.textContent = "Use Script";
    const copy = document.createElement("button"); copy.className = "copy"; copy.textContent = "⧉";
    actions.appendChild(use); actions.appendChild(copy);
    card.appendChild(img); card.appendChild(h3); card.appendChild(p); card.appendChild(actions);
    cards.appendChild(card);
    copy.addEventListener('click', () => {
      const text = `-- sample snippet for Script ${i}`;
      if(navigator.clipboard){
        navigator.clipboard.writeText(text).then(()=>alert("Snippet copied to clipboard."));
      } else {
        alert("Clipboard not available. Copy manually:\n\n" + text);
      }
    });
    use.addEventListener('click', () => {
      alert("Preview mode: this UI does not execute scripts.\nYou can copy the snippet to clipboard.");
    });
  }
});
