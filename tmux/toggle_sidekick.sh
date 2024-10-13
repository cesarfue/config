#!/bin/bash

current_panes_numbers() {
  tmux list-panes | wc -l | sed 's/ //g'
}

if [ -z "$sidekick_id" ]; then
    echo "No sidekick, splitting window..."
    tmux split-window -hb -c "#{pane_current_path}" -l 50
    sidekick_id=$(tmux display-message -p "#{pane_id}")
elif [[ $(current_panes_numbers) -eq 2 && -n "$sidekick_id" ]]; then
    echo "Sidekick is here, breaking it..."
    tmux select-pane -t "$sidekick_id"
    tmux break-pane -d
elif [[ $(current_panes_numbers) -eq 3 ]]; then
    echo "Three panes, joining sidekick pane..."
    tmux join-pane -s "$sidekick_id" -hb -l 50
fi
