import './main.css';
import { Elm } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

let initialNtree = [
    {
        nid: "root",
        pid: null,
        kind: {
            name: "pages",
            title: "Pages"
        },
        branch: [
            {
                nid: "1",
                hidden: false,
                link: false
            }
        ]
    },
    {
        nid: "1",
        pid: null,
        kind: {
            name: "page",
            title: "page1",
            style: { size: "full" }
        },
        branch: [
            {
                nid: "2",
                hidden: false,
                link: false
            }
        ]
    },
    {
        nid: "2",
        pid: "1",
        kind:{
            name: "collection",
            title: "Collection",
            style: { dir: "vertical" },
        },
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
