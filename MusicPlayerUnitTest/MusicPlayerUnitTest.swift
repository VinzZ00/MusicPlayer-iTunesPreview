//
//  UnitTest.swift
//  UnitTest
//
//  Created by Elvin Sestomi on 02/03/25.
//

import XCTest
import MusicPlayer

final class UnitTest: XCTestCase {

    var viewModel: ViewModel?
    override func setUpWithError() throws {
        viewModel = ViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testArtistUnknown() throws {
        
        viewModel?.fetchMusicData(artisName: "adsfjasdkfljalsdfkjl")
        XCTAssertNotNil(viewModel?.getMusicList())
        XCTAssertEqual(viewModel?.getMusicList().count, 0)
    }

    func testPerformanceFetchData() throws {
        // mengecek lama nya setiap fetching data: dari hasil test, AVG
        measure {
            viewModel?.fetchMusicData()
            XCTAssertNotNil(viewModel?.getMusicList())
        }
    }

}
