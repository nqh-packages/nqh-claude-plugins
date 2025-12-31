#!/usr/bin/env node
/**
 * @what Generates root README.md from plugin READMEs
 * @why Auto-imports one-liner + visual from each plugin
 */

import { readFileSync, writeFileSync, readdirSync } from 'fs';
import { join } from 'path';

const PLUGINS_DIR = join(import.meta.dirname, '../plugins');
const README_PATH = join(import.meta.dirname, '../README.md');

const START_MARKER = '<!-- AUTO-GENERATED: run `bun run build:readme` to update -->';
const END_MARKER = '<!-- END AUTO-GENERATED -->';

function extractPluginContent(pluginName) {
  const readmePath = join(PLUGINS_DIR, pluginName, 'README.md');
  const content = readFileSync(readmePath, 'utf-8');
  const lines = content.split('\n');

  // Extract one-liner (first non-empty line after # Title)
  let oneLiner = '';
  let foundTitle = false;
  for (const line of lines) {
    if (line.startsWith('# ')) {
      foundTitle = true;
      continue;
    }
    if (foundTitle && line.trim()) {
      oneLiner = line.trim();
      break;
    }
  }

  // Extract first code block (visual banner)
  const codeBlockMatch = content.match(/```[\s\S]*?```/);
  const visual = codeBlockMatch ? codeBlockMatch[0] : '';

  return { name: pluginName, oneLiner, visual };
}

function buildPluginsSection() {
  const plugins = readdirSync(PLUGINS_DIR, { withFileTypes: true })
    .filter(d => d.isDirectory())
    .map(d => extractPluginContent(d.name));

  return plugins.map(p => `### [${p.name}](./plugins/${p.name}/)

${p.oneLiner}

${p.visual}`).join('\n\n');
}

function updateReadme() {
  const readme = readFileSync(README_PATH, 'utf-8');
  const pluginsSection = buildPluginsSection();

  const before = readme.split(START_MARKER)[0];
  const after = readme.split(END_MARKER)[1];

  const newReadme = `${before}${START_MARKER}

${pluginsSection}

${END_MARKER}${after}`;

  writeFileSync(README_PATH, newReadme);
  console.log('✓ README.md updated');
}

updateReadme();
