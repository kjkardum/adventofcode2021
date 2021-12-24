
const filename = "input.txt"

const lines =  require('fs').readFileSync(filename).toString().split("\n");
const args = process.argv.slice(2);

const runALU = (data, MONAD, log=false) => {
    const variables = {
        x: 0, y: 0, z: 0, w: 0
    };
    const usefulData = {
        z26: [], a: [], b: [], w: []
    }
    data.some((el, index) => {
        const [func, ...args] = el.split(" ");
        let a = variables[args[0]];
        let b = variables[args[1]] ?? parseInt(args[1]);
        if (index%18  == 5) usefulData.a.push(b);
        if (index%18  == 15) usefulData.b.push(b);
        switch (func) {
            case "inp":
                let next = MONAD.next();
                if(index!==0) usefulData.z26.push({z: variables.z, z26: variables.z % 26, sign: [0,1,2,5,6,8,9].includes(usefulData.z26.length) ? ' - ' : '+++'});
                if (index !== 0 && usefulData.a[usefulData.a.length-1] < 0) {
                    log && console.log(usefulData.a)
                    if (!usefulData.z26.map(z26=>z26.z).slice(0,usefulData.z26.length-1).
                            includes(usefulData.z26[usefulData.z26.length-1].z)) {
                        log && console.log("QUIT", usefulData.z26);
                        return true;
                    }
                }
                variables[args[0]] = (next.done ? 1 : next.value[1]);
                usefulData.w.push(variables.w);
                log && console.log(`=> v(x=${variables.x}, y=${variables.y}, z=${variables.z}, w=${variables.w})`);
                break;
            case "add":
                variables[args[0]] += b;
                break;
            case "mul":
                variables[args[0]] *= b;
                break;
            case "div":
                if (b===0) throw new Error("Division by zero");
                variables[args[0]] = parseInt(
                    a / b
                );
                break;
            case "mod":
                if (a < 0 || b<=0 ) throw new Error("Modulo by zero or negative");
                variables[args[0]] %= b;
                break;
            case "eql":
                variables[args[0]] = a === b ? 1 : 0;
                break;
        };
    });
    log && usefulData.z26.push({z: variables.z, z26: variables.z % 26, sign: [0,1,2,5,6,8,9].includes(usefulData.z26.length) ? ' - ' : '+++'})
    log && console.table(usefulData.z26.map((el, index) => {
        return {
            z: el.z,
            z26: el.z26,
            b: usefulData.b[index],
            w: usefulData.w[index],
            a: usefulData.a[index],
            sign: el.sign
        };
    }));
    return variables.z;
}


if (args[0] === "a") {
    mini = 99999999999999;
    maxi = 11111111111111;
    for (let i=11111111111111; i<=99999999999999; i++) {
        if (i.toString().includes("0")) continue;
        let calculated = runALU(lines, Array.from(i.toString()).map(el => parseInt(el)).entries());
        if (!calculated) {
            maxi = Math.max(maxi, i);
            mini = Math.min(mini, i);
            console.log(mini);
        }
        if (i % 1111111 === 0) console.log(i);
    }
} else {
    let MONAD = Array.from(args[0] ?? '').map(i=>parseInt(i)).entries();  
    runALU(lines, MONAD, log=true);
}

// We are looking for matching pairs for z26 for different signs.
// With this as tester, we can check results, the smallest and biggest can be found for
// 41299994879959 11189561113216