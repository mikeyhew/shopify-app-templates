import {Reducer} from "redux";

export type Action =
    | {"type": "some-action"};

export type State = {
    // nothing yet
};

export const reducer: Reducer<State, Action> = (state: State = {}, action: Action) => {
    switch (action.type) {
        case "some-action":
            return state;
    }
};
