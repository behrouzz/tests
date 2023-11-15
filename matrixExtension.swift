// Convert between JSON and Swift names

import Cocoa
/*
extension Array<Double> {
    func mul(_ secondArray: Array<Double>) -> Double {
        var n = 0.0
        for i in self.indices {
            n += self[i] * secondArray[i]
        }
        return n
    }
}
*/


extension Array<Double> {
    static func *(lhs: Array<Double>, rhs: Array<Double>) -> Double {
        var n = 0.0
        for i in lhs.indices {
            n += lhs[i] * rhs[i]
        }
        return n
    }
}


extension Array<[Double]> {
    func T() -> Array<[Double]> {
        let nrows = self.count
        let ncols = self[0].count
        var newArray = [[Double]]()
        for _ in 0..<ncols {
            newArray.append([Double](repeating: 0.0, count: nrows))
        }
        
        for i in 0..<nrows {
            for j in 0..<ncols {
                newArray[j][i] = self[i][j]
            }
        }
        
        return newArray
    }
}


extension Array<[Double]> {
    static func *(lhs: Array<[Double]>, rhs: Array<[Double]>) -> Array<[Double]>? {
        let ncols1 = lhs[0].count
        let nrows1 = lhs.count
        let ncols2 = rhs[0].count
        let nrows2 = rhs.count
        
        //var tmp: Double
        
        var newArray = [[Double]]()
        for _ in 0..<nrows1 {
            newArray.append([Double](repeating: 0.0, count: ncols2))
        }
        
        if ncols1 == nrows2 {
            for n in 0..<nrows1 {
                //tmp = 0.0
                for p in 0..<ncols2 {
                    newArray[n][p] = lhs[n] * rhs.T()[p]
                }
                //newArray[n].append(tmp)
            }
            return newArray
        } else {
            return nil
        }
    }
}




let a = [
    [2.0, 5.0, 4.0],
    [8.0, 1.0, 3.0],
    [3.0, 2.0, 6.0],
    [5.0, 4.0, 7.0],
    [2.0, 7.0, 8.0],
]

let b = [
    [2.0, 2.0, 2.0, 1.0, 5.0],
    [1.0, 7.0, 2.0, 6.0, 3.0],
    [5.0, 3.0, 9.0, 2.0, 4.0]
]

let c = a * b

print(c ?? [[0.0]])

//print(newArray.T())
