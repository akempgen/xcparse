//
//  ConsoleIO.swift
//  xcparse
//
//  Created by Rishab Sukumar on 8/8/19.
//  Copyright © 2019 ChargePoint, Inc. All rights reserved.
//

import Foundation

enum OutputType {
  case error
  case standard
}

class Console {
    
    func writeMessage(_ message: String, to: OutputType = .standard) {
      switch to {
      case .standard:
        print("\(message)")
      case .error:
        fputs("Error: \(message)\n", stderr)
      }
    }
    
    func printUsage() {

        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        writeMessage("usage (static mode): xcparse [-hq] [-s xcresultPath destination] [-x xcresultPath destination]\n")
        writeMessage("usage (interactive mode): xcparse\n")
        writeMessage(" -s, --screenshots : Extracts screenshots from xcresult file at xcresultPath and saves it in destination folder")
        writeMessage(" -x, --xcov : Extracts coverage from xcresult file at xcresultPath and saves it in destination folder")
        writeMessage(" -h, --help : Prints usage message")
        writeMessage(" -q, --quit : Exits interactive mode. Cannot be used in static mode.")
    }
    
    // MARK: -
    // MARK: Shell
    // user3064009's answer on https://stackoverflow.com/questions/26971240/how-do-i-run-an-terminal-command-in-a-swift-script-e-g-xcodebuild
    func shellCommand(_ command: String) -> String {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        
        return output
    }
    
    func getInput() -> String {
      let keyboard = FileHandle.standardInput
      let inputData = keyboard.availableData
      let strData = String(data: inputData, encoding: String.Encoding.utf8)!
      return strData.trimmingCharacters(in: CharacterSet.newlines)
    }

}
