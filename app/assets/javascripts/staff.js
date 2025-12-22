// VexFlow EasyScore renderer for music staff notation
// Renders SVG staves from data-easyscore attributes on .staff elements

document.addEventListener('DOMContentLoaded', function() {
  if (typeof Vex === 'undefined' || !Vex.Flow) {
    console.error('VexFlow not loaded!');
    return;
  }

  initializeStaves();
});

function initializeStaves() {
  const { Renderer, Stave, StaveNote, Voice, Formatter, Accidental } = Vex.Flow;

  document.querySelectorAll('.staff').forEach(function(element, index) {
    // Skip if already rendered
    if (element.querySelector('svg')) return;
    
    const easyscore = element.dataset.easyscore;
    if (!easyscore) return;

    const clef = element.dataset.clef || 'treble';
    // Use data-width for the logical layout width (coordinate system), 
    // and let CSS scale the SVG to fit the container.
    const width = parseInt(element.dataset.width) || 300;
    const height = parseInt(element.dataset.height) || 150;

    // Assign unique ID if not present
    if (!element.id) {
      element.id = 'vexflow-staff-' + index;
    }

    try {
      // Create SVG renderer
      const renderer = new Renderer(element, Renderer.Backends.SVG);
      renderer.resize(width, height);
      const context = renderer.getContext();
      
      // Remove fixed dimensions from SVG style to allow CSS resizing
      const svg = element.querySelector('svg');
      if (svg) {
        svg.style.width = '100%';
        svg.style.height = '100%';
        svg.setAttribute('width', '100%');
        svg.setAttribute('height', '100%');
        // Ensure viewBox is present (VexFlow adds it, but just to be safe)
        if (!svg.getAttribute('viewBox')) {
          svg.setAttribute('viewBox', `0 0 ${width} ${height}`);
        }
      }

      // Create stave with proper margins (x=0 for left margin, y=25 for top margin to center vertically in 150px height)
      // We use nearly full width for the stave since we're inside a dedicated viewBox
      const staveWidth = width - 1; 
      const stave = new Stave(0, 25, staveWidth);
      stave.addClef(clef);
      stave.setContext(context).draw();

      // Parse EasyScore notation and create notes
      const notes = parseEasyScore(easyscore, clef);
      
      // Create voice with loose timing
      const voice = new Voice({ num_beats: notes.length * 4, beat_value: 4 });
      voice.setStrict(false);
      voice.addTickables(notes);

      // Format and draw
      new Formatter().joinVoices([voice]).format([voice], staveWidth - 20);
      voice.draw(context, stave);

    } catch (error) {
      console.error('VexFlow rendering error for:', easyscore, error);
    }
  });

  // Parse EasyScore notation string into StaveNote objects
  function parseEasyScore(notation, clef) {
    const notes = [];
    const parts = notation.split(',').map(s => s.trim());
    
    let currentDuration = 'q'; // default quarter note
    
    for (const part of parts) {
      // Check if it's a chord (contains parentheses)
      const chordMatch = part.match(/^\(([^)]+)\)\/(\w+)$/);
      if (chordMatch) {
        const chordNotes = chordMatch[1].split(' ').map(n => n.trim());
        currentDuration = chordMatch[2];
        const keys = chordNotes.map(n => parseNoteKey(n));
        const note = new StaveNote({ clef: clef, keys: keys, duration: currentDuration });
        addAccidentals(note, chordNotes);
        notes.push(note);
        continue;
      }
      
      // Single note with duration
      const noteMatch = part.match(/^([A-Ga-g][#b]?\d)(?:\/(\w+))?$/);
      if (noteMatch) {
        const noteName = noteMatch[1];
        if (noteMatch[2]) currentDuration = noteMatch[2];
        const key = parseNoteKey(noteName);
        const note = new StaveNote({ clef: clef, keys: [key], duration: currentDuration });
        addAccidentals(note, [noteName]);
        notes.push(note);
      }
    }
    
    return notes;
  }

  // Convert note name (e.g., "C#4") to VexFlow key format (e.g., "c#/4")
  function parseNoteKey(noteName) {
    const match = noteName.match(/^([A-Ga-g])([#b]?)(\d)$/);
    if (match) {
      return match[1].toLowerCase() + match[2] + '/' + match[3];
    }
    return noteName.toLowerCase();
  }

  // Add accidentals to a note
  function addAccidentals(staveNote, noteNames) {
    noteNames.forEach((name, i) => {
      if (name.includes('#')) {
        staveNote.addModifier(new Accidental('#'), i);
      } else if (name.includes('b')) {
        staveNote.addModifier(new Accidental('b'), i);
      }
    });
  }
}
