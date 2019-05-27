import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

let initialNtree = [
    {
        nid: "1",
        pid: null,
        name: "page",
        settings: {
            name: "page1"
        },
        style: { size: "full" },
        branch: [
            ["2", "visible", "direct"]
        ]
    },
    {
        nid: "2",
        pid: "1",
        name: "collection",
        settings: {
            name: "Collection"
        },
        style: { dir: "vertical" },
        branch: null
    }

]

Elm.Main.init({
    node: document.getElementById('root'),
    flags: {
        seed: 3,
        ntree: JSON.stringify(initialNtree)
    }
});

registerServiceWorker();
