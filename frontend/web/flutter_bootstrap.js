{{flutter_js}}
{{flutter_build_config}}

// Custom loading progress handler
const loadingText = document.getElementById('loading-text');
const progressFill = document.getElementById('progress-fill');
const loadingScreen = document.getElementById('loading');

function updateProgress(text, percentage) {
  if (loadingText) loadingText.textContent = text;
  if (progressFill) progressFill.style.width = percentage + '%';
}

// Stage 1: Loading entrypoint
updateProgress('Loading application...', 20);

// Initialize Firebase early if needed
if (typeof firebase !== 'undefined') {
  updateProgress('Initializing services...', 40);
}

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    // Stage 2: Initializing Flutter engine
    updateProgress('Initializing engine...', 60);
    
    const appRunner = await engineInitializer.initializeEngine({
      // Add any engine configuration here
    });

    // Stage 3: Running the app
    updateProgress('Starting app...', 80);
    await appRunner.runApp();

    // Stage 4: Complete
    updateProgress('Ready!', 100);
    
    // Remove loading screen after a brief delay
    setTimeout(() => {
      if (loadingScreen) {
        loadingScreen.classList.add('loaded');
        // Remove from DOM after fade out
        setTimeout(() => {
          loadingScreen.remove();
        }, 500);
      }
    }, 300);
  }
});
