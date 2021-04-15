# Algo Trading 101 

This is a comprehensible Introduction to Algo Trading for the members of TU I, to raise curiosity and resurrect Alternative Strategies/Assets.
The objective is a comprehensive overview in three lectures including 
- Data Collection, Preparation and Manipulation, 
- Model Selection and Discussion,
- Backtesting and Portfolio Strategy.

*To limit our time spent per section, basics in Python and Statistics are welcomed. If not, there will be links to a Backup Section with additional code and explanations.*

## Contents


<h1>Table of contents</h1>

<div class="alert alert-block alert-info" style="text-decoration:none; margin-top: 30px; background-color:#F2F2F2; border-color:#022F73">
    <span style="color:#022F73">
    <ol>
      <li><a href="#1"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Intro  </span> </a></li>
          <ol>
      <li><a href="#2"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >A comprehensive Overview  </span> </a></li>
      <li><a href="#2"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Definition of AlgoTrading  </span> </a></li>
      <li><a href="#3"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Benefits of an algorithmic approach</span> </a></li>
      <li><a href="#4"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Our Focus and Scope</span> </a></li>
        </ol>
      <li><a href="#5"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Raw Data </span> </a></li>
       <ol>
       <li><a href="#6"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Provider and APIs </span> </a></li>
       <li><a href="#7"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Let's limit our universe: What Markets and Instruments are fit for the start </span> </a></li>
       <li><a href="#6"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Data Snooping: p-Hacking, SVD and PCA </span> </a></li>
       </ol>   
       <li><a href="#8"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Preferred Statistical Characteristics of Data</span> </a></li>
       <ol>
       <li><a href="#9"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Skewness and Kurtosis</span> </a></li>
       <li><a href="#10"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Stationarity </span> </a></li>    
       <li><a href="#11"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Integration</span> </a></li>
       <li><a href="#12"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Cointegration </span> </a></li>     
       <li><a href="#19"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Todays Objective: processed dataset for our next lecture </span> </a></li>
       </ol>
       <li><a href="#13"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >The  Basic Strategies as Foundation</span> </a></li> 
       <ol>
          <li><a href="#17"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Mean Reversion and Moving Average</span> </a></li>
       <li><a href="#17"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Trend Based: Momentum</span> </a></li>
       <li><a href="#18"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Pairs Trading</span> </a></li>
       <li><a href="#18"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Long-Short Equity</span> </a></li>       
       </ol>   
       <li><a href="#13"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Advanced Manipulation to gain an Edge</span> </a></li> 
       <ol>
   <li><a href="#16"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Hurst Exponents </span> </a></li>
       <li><a href="#18"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Ornstein-Uhlenbeck </span> </a></li>
       <li><a href="#15"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Kalman Filter </span> </a></li>    
       <li><a href="#18"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Haar Transformation </span> </a></li>
       <li><a href="#17"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Exponential Smoothing </span> </a></li> 
       </ol>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Artificial Intelligence</span> </a></li>
       <ol>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Deep Neural Networks (DNN)</span> </a></li>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Gradient-Boosted-Trees (GBT)</span> </a></li>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Random Forests (RAF)</span> </a></li>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Reinforcement Learning (RL)</span> </a></li>
       </ol>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Positions</span> </a></li>
       <ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Thresholds for Entry and Exit</span> </a></li>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Position Sizing</span> </a></li>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Leverage</span> </a></li>
       </ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Backtesting</span> </a></li>
       <ol>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Biases: Look-Ahead, Survivorship and Optimization</span> </a></li>    
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Volume, Slippage, Liquidity and other Costs</span> </a></li>   
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Libraries</span> </a></li>      
        </ol>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Performance</span> </a></li>
       <ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Basics: Alpha and Beta</span> </a></li>   
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Portfolio Overview: Returns, Risk and Drawdown</span> </a></li>  
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Beta Hedging</span> </a></li>        
        </ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Portfolio Strategy</span> </a></li>
       <ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Markowitz</span> </a></li>    
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Risk-Constrained Portfolio Optimization</span> </a></li>      
        </ol> 
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >APPENDIX</span> </a></li>
        <ol>
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Outlook for Part II: Derivatives, Big Data and Sentiment Analysis</span> </a></li>    
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Additional Sources</span> </a></li> 
        <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Statistics 101</span> </a></li>
       <li><a href="#20"> <span style="color:#022F73;text-decoration:underline;text-decoration-color:#F2F2F2" 
       >Python 101</span> </a></li> 
        </ol>
    </ol>
    </span>
</div>




## Preliminary lecture structure


| Lecture | Chapter | Content | in Lecture | as Homework | 
| ------ | ------ | ------ | ------ | ------ |
| 1 | 1 | **Intro**  | 
| 1 | a | A comprehensive Overview  | &#9745;
| 1 | b | Definition of AlgoTrading  | &#9745;
| 1 | c | Benefits of an algorithmic approach  | &#9745;
| 1 | d | Our Focus and Scope  | &#9745;
| 1 | 2 | **Raw Data**  | 
| 1 | a | Provider and APIs  | &#9745;
| 1 | b | Let's limit our universe: What Markets and Instruments are fit for the start  | &#9745;
| 1 | c | Data Snooping: p-Hacking, SVD and PCA  | | &#9745;
| 1 | 3 | **Preferred Statistical Characteristics of Data**  | &#9745;
| 1 | a | Skewness and Kurtosis  | &#9745;
| 1 | b | Stationarity  | &#9745;
| 1 | c | Integration  | &#9745;
| 1 | d | Cointegration | &#9745;
| 1 | e | Todays Objective: processed dataset for our next lecture  | | &#9745;
| 2 | 4 | **The Basic Strategies as Foundation**  | 
| 2 | a | Mean Reversion and Moving Average  | &#9745;
| 2 | b | Trend Based: Momentum  | &#9745;
| 2 | c | Pairs Trading  | &#9745;
| 2 | d | Long-Short Equity  | | &#9745;
| 2 | 5 | **Advanced Manipulation to gain an Edge**  | 
| 2 | a | Hurst Exponents  |  | &#9745;
| 2 | b | Ornstein-Uhlenbeck  |  | &#9745;
| 2 | c | Kalman Filter  | &#9745;
| 2 | d | Haar Transformation  | &#9745;
| 2 | e | Exponential Smoothing  |  | &#9745;
| 2 | 6 | **Artificial Intelligence** | &#9745;
| 2 | a | Deep Neural Networks (DNN)  |  | &#9745;
| 2 | b | Gradient-Boosted-Trees (GBT)  |  | &#9745;
| 2 | c | Random Forests (RAF)  |  | &#9745;
| 2 | d | Reinforcement Learning (RL)  |  | &#9745;
| 2 | 7 | **Positions**  | &#9745;
| 2 | a | Thresholds for Entry and Exit  | &#9745;
| 2 | b | Position Sizing  | &#9745;
| 2 | c | Leverage  |  | &#9745;
| 3 | 8 | **Backtesting**  | &#9745;
| 3 | a | Biases: Look-Ahead, Survivorship and Optimization  | &#9745;
| 3 | b | Volume, Slippage, Liquidity and other Costs  | &#9745;
| 3 | c | Libraries  |  | &#9745;
| 3 | 9 | **Performance**  | &#9745;
| 3 | a | Basics: Alpha and Beta  | &#9745;
| 3 | b | Portfolio Overview: Returns, Risk and Drawdown  | &#9745;
| 3 | c | Beta Hedging  |  &#9745;
| 3 | 10 | **Portfolio Strategy**  | &#9745;
| 3 | a | Markowitz  | &#9745;
| 3 | b | Risk-Constrained Portfolio Optimization  |  | &#9745;
| 3 | 11 | **APPENDIX**  | 
| 3 | a | Outlook for Part II: Derivatives, Big Data and Sentiment Analysis  | | &#9745;
| 3 | b | Additional Sources  | | &#9745;
| 3 | c | Statistics 101  | | &#9745;
| 3 | d | Python 101  | | &#9745;